import React, { useState } from 'react';
import { BarChart3, LineChart, PieChart, Info, Download } from 'lucide-react';

const PALETTE = [
  '#2563eb', // Blue
  '#0d9488', // Teal
  '#d97706', // Amber
  '#7c3aed', // Purple
  '#db2777', // Pink
  '#16a34a', // Green
  '#ea580c', // Orange
  '#4f46e5', // Indigo
];

export default function ChartRenderer({ chart }) {
  const [hoveredIndex, setHoveredIndex] = useState(null);

  if (!chart || !chart.data || !Array.isArray(chart.data) || chart.data.length === 0) {
    return (
      <div className="chart-empty-state">
        <Info size={18} className="text-muted" />
        <span>Insufficient data is available to generate this chart.</span>
      </div>
    );
  }

  const { type = 'bar', title = 'Chart Analysis', x_axis = '', y_axis = '', data } = chart;

  // Filter valid data items
  const validData = data.filter(d => d && typeof d.value === 'number' && !isNaN(d.value));
  if (validData.length === 0) {
    return (
      <div className="chart-empty-state">
        <Info size={18} className="text-muted" />
        <span>Insufficient data is available to generate this chart.</span>
      </div>
    );
  }

  const values = validData.map(d => d.value);
  const maxValue = Math.max(...values, 0);
  const minValue = Math.min(...values, 0);
  const valueRange = maxValue === minValue ? (maxValue === 0 ? 1 : maxValue) : (maxValue - minValue);

  // Helper for icons
  const renderIcon = () => {
    switch (type) {
      case 'line':
        return <LineChart size={18} className="chart-icon" />;
      case 'pie':
        return <PieChart size={18} className="chart-icon" />;
      case 'bar':
      default:
        return <BarChart3 size={18} className="chart-icon" />;
    }
  };

  // 1. Render Bar Chart (SVG)
  const renderBarChart = () => {
    const width = 600;
    const height = 300;
    const padLeft = 60;
    const padRight = 30;
    const padTop = 30;
    const padBottom = 60;

    const plotWidth = width - padLeft - padRight;
    const plotHeight = height - padTop - padBottom;
    const barWidth = Math.min(48, Math.max(16, (plotWidth / validData.length) * 0.65));
    const step = plotWidth / validData.length;

    // Y ticks
    const yTicks = [0, 0.25, 0.5, 0.75, 1].map(ratio => {
      const val = minValue + ratio * valueRange;
      const yPos = padTop + plotHeight - ratio * plotHeight;
      return { val: Math.round(val * 10) / 10, yPos };
    });

    return (
      <svg viewBox={`0 0 ${width} ${height}`} className="cams-chart-svg">
        <defs>
          <linearGradient id="barGradient" x1="0%" y1="0%" x2="0%" y2="100%">
            <stop offset="0%" stopColor="#3b82f6" />
            <stop offset="100%" stopColor="#1d4ed8" />
          </linearGradient>
          <linearGradient id="barHoverGradient" x1="0%" y1="0%" x2="0%" y2="100%">
            <stop offset="0%" stopColor="#60a5fa" />
            <stop offset="100%" stopColor="#2563eb" />
          </linearGradient>
        </defs>

        {/* Grid lines & Y tick labels */}
        {yTicks.map((tick, i) => (
          <g key={i}>
            <line
              x1={padLeft}
              y1={tick.yPos}
              x2={width - padRight}
              y2={tick.yPos}
              stroke="#e2e8f0"
              strokeDasharray="4 4"
            />
            <text
              x={padLeft - 10}
              y={tick.yPos + 4}
              textAnchor="end"
              fontSize="11"
              fill="#64748b"
            >
              {tick.val}
            </text>
          </g>
        ))}

        {/* Bars and X labels */}
        {validData.map((d, i) => {
          const x = padLeft + i * step + (step - barWidth) / 2;
          const barHeight = Math.max(4, ((d.value - Math.min(0, minValue)) / (valueRange || 1)) * plotHeight);
          const y = padTop + plotHeight - barHeight;
          const isHovered = hoveredIndex === i;

          return (
            <g
              key={i}
              onMouseEnter={() => setHoveredIndex(i)}
              onMouseLeave={() => setHoveredIndex(null)}
              style={{ cursor: 'pointer' }}
            >
              <rect
                x={x}
                y={y}
                width={barWidth}
                height={barHeight}
                rx={4}
                fill={isHovered ? "url(#barHoverGradient)" : "url(#barGradient)"}
                filter={isHovered ? "drop-shadow(0px 4px 6px rgba(37,99,235,0.3))" : "none"}
                style={{ transition: 'all 0.2s ease' }}
              />
              {/* Value label on top of bar */}
              <text
                x={x + barWidth / 2}
                y={y - 6}
                textAnchor="middle"
                fontSize="11"
                fontWeight="600"
                fill={isHovered ? "#1e3a8a" : "#475569"}
              >
                {d.value}
              </text>
              {/* X label */}
              <text
                x={x + barWidth / 2}
                y={height - padBottom + 18}
                textAnchor="middle"
                fontSize="11"
                fill="#475569"
                transform={validData.length > 5 ? `rotate(-25, ${x + barWidth / 2}, ${height - padBottom + 18})` : undefined}
              >
                {String(d.label).length > 14 ? `${String(d.label).slice(0, 12)}...` : d.label}
              </text>
            </g>
          );
        })}

        {/* Axis titles */}
        {y_axis && (
          <text
            x={15}
            y={height / 2}
            textAnchor="middle"
            fontSize="11"
            fill="#64748b"
            fontWeight="500"
            transform={`rotate(-90, 15, ${height / 2})`}
          >
            {y_axis}
          </text>
        )}
        {x_axis && (
          <text
            x={width / 2}
            y={height - 8}
            textAnchor="middle"
            fontSize="11"
            fill="#64748b"
            fontWeight="500"
          >
            {x_axis}
          </text>
        )}
      </svg>
    );
  };

  // 2. Render Line Chart (SVG)
  const renderLineChart = () => {
    const width = 600;
    const height = 300;
    const padLeft = 60;
    const padRight = 30;
    const padTop = 30;
    const padBottom = 60;

    const plotWidth = width - padLeft - padRight;
    const plotHeight = height - padTop - padBottom;
    const step = validData.length > 1 ? plotWidth / (validData.length - 1) : plotWidth;

    const points = validData.map((d, i) => {
      const x = validData.length === 1 ? padLeft + plotWidth / 2 : padLeft + i * step;
      const ratio = valueRange > 0 ? (d.value - minValue) / valueRange : 0.5;
      const y = padTop + plotHeight - ratio * plotHeight;
      return { x, y, ...d };
    });

    const pathD = points.length === 1
      ? `M ${points[0].x} ${points[0].y}`
      : points.map((p, i) => `${i === 0 ? 'M' : 'L'} ${p.x} ${p.y}`).join(' ');

    const areaD = points.length > 1
      ? `${pathD} L ${points[points.length - 1].x} ${padTop + plotHeight} L ${points[0].x} ${padTop + plotHeight} Z`
      : '';

    // Y ticks
    const yTicks = [0, 0.25, 0.5, 0.75, 1].map(ratio => {
      const val = minValue + ratio * valueRange;
      const yPos = padTop + plotHeight - ratio * plotHeight;
      return { val: Math.round(val * 10) / 10, yPos };
    });

    return (
      <svg viewBox={`0 0 ${width} ${height}`} className="cams-chart-svg">
        <defs>
          <linearGradient id="lineAreaGradient" x1="0%" y1="0%" x2="0%" y2="100%">
            <stop offset="0%" stopColor="#3b82f6" stopOpacity="0.25" />
            <stop offset="100%" stopColor="#3b82f6" stopOpacity="0.0" />
          </linearGradient>
        </defs>

        {/* Grid lines */}
        {yTicks.map((tick, i) => (
          <g key={i}>
            <line
              x1={padLeft}
              y1={tick.yPos}
              x2={width - padRight}
              y2={tick.yPos}
              stroke="#e2e8f0"
              strokeDasharray="4 4"
            />
            <text
              x={padLeft - 10}
              y={tick.yPos + 4}
              textAnchor="end"
              fontSize="11"
              fill="#64748b"
            >
              {tick.val}
            </text>
          </g>
        ))}

        {/* Shaded Area */}
        {areaD && <path d={areaD} fill="url(#lineAreaGradient)" />}

        {/* Line */}
        <path
          d={pathD}
          fill="none"
          stroke="#2563eb"
          strokeWidth="3"
          strokeLinecap="round"
          strokeLinejoin="round"
        />

        {/* Points */}
        {points.map((p, i) => {
          const isHovered = hoveredIndex === i;
          return (
            <g
              key={i}
              onMouseEnter={() => setHoveredIndex(i)}
              onMouseLeave={() => setHoveredIndex(null)}
              style={{ cursor: 'pointer' }}
            >
              <circle
                cx={p.x}
                cy={p.y}
                r={isHovered ? 6 : 4}
                fill="#ffffff"
                stroke="#2563eb"
                strokeWidth={isHovered ? 3 : 2}
                style={{ transition: 'all 0.15s ease' }}
              />
              <text
                x={p.x}
                y={p.y - 10}
                textAnchor="middle"
                fontSize="11"
                fontWeight="600"
                fill={isHovered ? "#1e3a8a" : "#475569"}
              >
                {p.value}
              </text>
              <text
                x={p.x}
                y={height - padBottom + 18}
                textAnchor="middle"
                fontSize="11"
                fill="#475569"
                transform={points.length > 5 ? `rotate(-25, ${p.x}, ${height - padBottom + 18})` : undefined}
              >
                {String(p.label).length > 14 ? `${String(p.label).slice(0, 12)}...` : p.label}
              </text>
            </g>
          );
        })}

        {/* Axis titles */}
        {y_axis && (
          <text
            x={15}
            y={height / 2}
            textAnchor="middle"
            fontSize="11"
            fill="#64748b"
            fontWeight="500"
            transform={`rotate(-90, 15, ${height / 2})`}
          >
            {y_axis}
          </text>
        )}
        {x_axis && (
          <text
            x={width / 2}
            y={height - 8}
            textAnchor="middle"
            fontSize="11"
            fill="#64748b"
            fontWeight="500"
          >
            {x_axis}
          </text>
        )}
      </svg>
    );
  };

  // 3. Render Pie Chart (SVG)
  const renderPieChart = () => {
    const width = 500;
    const height = 300;
    const centerX = 160;
    const centerY = 150;
    const radius = 95;

    const total = validData.reduce((acc, d) => acc + (d.value > 0 ? d.value : 0), 0);
    if (total === 0) {
      return (
        <div className="chart-empty-state">
          <Info size={18} />
          <span>Cannot generate pie chart from zero or negative sums.</span>
        </div>
      );
    }

    let cumulativeAngle = 0;
    const slices = validData.map((d, i) => {
      const sliceVal = Math.max(0, d.value);
      const angle = (sliceVal / total) * 2 * Math.PI;
      const startAngle = cumulativeAngle;
      const endAngle = cumulativeAngle + angle;
      cumulativeAngle += angle;

      const x1 = centerX + radius * Math.cos(startAngle);
      const y1 = centerY + radius * Math.sin(startAngle);
      const x2 = centerX + radius * Math.cos(endAngle);
      const y2 = centerY + radius * Math.sin(endAngle);

      const largeArc = angle > Math.PI ? 1 : 0;
      const pathData = validData.length === 1
        ? `M ${centerX - radius} ${centerY} A ${radius} ${radius} 0 1 0 ${centerX + radius} ${centerY} A ${radius} ${radius} 0 1 0 ${centerX - radius} ${centerY}`
        : `M ${centerX} ${centerY} L ${x1} ${y1} A ${radius} ${radius} 0 ${largeArc} 1 ${x2} ${y2} Z`;

      const percentage = ((sliceVal / total) * 100).toFixed(1);
      const color = PALETTE[i % PALETTE.length];

      return {
        pathData,
        color,
        label: d.label,
        value: d.value,
        percentage
      };
    });

    return (
      <div className="pie-container">
        <svg viewBox={`0 0 ${width} ${height}`} className="cams-chart-svg pie-svg">
          {slices.map((slice, i) => {
            const isHovered = hoveredIndex === i;
            return (
              <path
                key={i}
                d={slice.pathData}
                fill={slice.color}
                stroke="#ffffff"
                strokeWidth="2"
                opacity={hoveredIndex === null || isHovered ? 1 : 0.6}
                onMouseEnter={() => setHoveredIndex(i)}
                onMouseLeave={() => setHoveredIndex(null)}
                style={{ cursor: 'pointer', transition: 'all 0.2s ease' }}
              />
            );
          })}
        </svg>

        {/* Custom Legend */}
        <div className="pie-legend">
          {slices.map((slice, i) => (
            <div
              key={i}
              className={`legend-item ${hoveredIndex === i ? 'legend-item-active' : ''}`}
              onMouseEnter={() => setHoveredIndex(i)}
              onMouseLeave={() => setHoveredIndex(null)}
            >
              <span className="legend-color-dot" style={{ backgroundColor: slice.color }}></span>
              <span className="legend-label">{slice.label}:</span>
              <span className="legend-val">{slice.value} ({slice.percentage}%)</span>
            </div>
          ))}
        </div>
      </div>
    );
  };

  return (
    <div className="cams-chart-card">
      <div className="chart-header">
        <div className="chart-title-group">
          {renderIcon()}
          <div>
            <h4 className="chart-title">{title}</h4>
            <span className="chart-subtitle">
              {validData.length} data point{validData.length === 1 ? '' : 's'} • E2B Sandbox Verified
            </span>
          </div>
        </div>
        <div className="chart-type-tag">
          {type.toUpperCase()}
        </div>
      </div>

      <div className="chart-body">
        {type === 'line' && renderLineChart()}
        {type === 'pie' && renderPieChart()}
        {(type === 'bar' || (type !== 'line' && type !== 'pie')) && renderBarChart()}
      </div>
    </div>
  );
}
