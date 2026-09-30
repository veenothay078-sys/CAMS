import React, { useState } from 'react';
import { Info } from 'lucide-react';

// Formal Academic Distinct Color Palette
const FORMAL_DISTINCT_PALETTE = [
  '#2457D6', // 1. Royal Blue
  '#E05252', // 2. Formal Crimson
  '#2E8B68', // 3. Forest Emerald
  '#D69A32', // 4. Golden Ochre
  '#7952B3', // 5. Academic Purple
  '#0D9488', // 6. Deep Teal
  '#EA580C', // 7. Warm Terracotta
  '#4F46E5', // 8. Rich Indigo
  '#0284C7', // 9. Sapphire
  '#B45309', // 10. Warm Amber
  '#4338CA', // 11. Dark Navy
  '#059669', // 12. Jade Green
];

/**
 * Returns a distinct formal color based on semantic category or palette index
 */
function getFormalColorForLabel(label, index) {
  if (!label) return FORMAL_DISTINCT_PALETTE[index % FORMAL_DISTINCT_PALETTE.length];
  const l = String(label).toLowerCase();
  
  if (l.includes('absent') || l.includes('shortage') || l.includes('fail') || l.includes('critical') || l.includes('risk') || l.includes('danger')) {
    return '#E05252'; // Crimson Red
  }
  if (l.includes('present') || l.includes('pass') || l.includes('active') || l.includes('good') || l.includes('excellent') || l.includes('success')) {
    return '#2E8B68'; // Forest Green
  }
  if (l.includes('leave') || l.includes('late') || l.includes('pending') || l.includes('rest leave') || l.includes('on leave')) {
    return '#D69A32'; // Golden Amber
  }
  if (l.includes('sunday') || l.includes('holiday') || l.includes('weekend') || l.includes('break')) {
    return '#7952B3'; // Academic Purple
  }
  return FORMAL_DISTINCT_PALETTE[index % FORMAL_DISTINCT_PALETTE.length];
}

export default function ChartRenderer({ chart, chartData }) {
  const [hoveredIndex, setHoveredIndex] = useState(null);

  const activeChart = chart || chartData;

  if (!activeChart || !activeChart.data || !Array.isArray(activeChart.data) || activeChart.data.length === 0) {
    return (
      <div style={{ padding: '2rem', textAlign: 'center', color: 'var(--text-secondary)', fontSize: '0.84rem' }}>
        <Info size={16} style={{ display: 'inline', marginRight: '6px' }} />
        <span>No chart data available to render.</span>
      </div>
    );
  }

  const { type = 'bar', title = '', x_label = '', y_label = '', x_axis = '', y_axis = '' } = activeChart;
  const rawData = activeChart.data;

  // Normalize data array
  const normalizedData = rawData.map((d, idx) => {
    let lbl = d.label || d.x || 'Item';
    let val = typeof d.value === 'number' ? d.value : (typeof d.y === 'number' ? d.y : 0);
    return {
      label: lbl,
      value: val,
      color: getFormalColorForLabel(lbl, idx),
      highlight: d.highlight
    };
  }).filter(d => typeof d.value === 'number');

  if (normalizedData.length === 0) {
    return (
      <div style={{ padding: '2rem', textAlign: 'center', color: 'var(--text-secondary)', fontSize: '0.84rem' }}>
        <span>No quantifiable metrics to visualize.</span>
      </div>
    );
  }

  const values = normalizedData.map(d => d.value);
  const maxValue = Math.max(...values, 10);

  // 1. Render Bar Chart with Distinct Formal Colors
  const renderBarChart = () => {
    const height = 195;
    const isPercentage = activeChart.y_axis?.toLowerCase().includes('%') || 
      activeChart.y_axis?.toLowerCase().includes('percent') || 
      activeChart.title?.toLowerCase().includes('percent') || 
      activeChart.title?.toLowerCase().includes('attendance') ||
      normalizedData.some(d => d.value <= 100 && d.value > 0 && String(d.value).includes('.'));

    return (
      <div style={{ display: 'flex', alignItems: 'flex-end', gap: '0.75rem', height: `${height}px`, paddingTop: '1.5rem', paddingBottom: '0.5rem', borderBottom: '1px solid var(--border-color)', overflowX: 'auto' }}>
        {normalizedData.map((d, idx) => {
          const barHeight = Math.max((d.value / maxValue) * (height - 42), 8);
          const isHovered = hoveredIndex === idx;
          const barColor = d.color;
          return (
            <div 
              key={idx} 
              style={{ flex: 1, minWidth: '45px', display: 'flex', flexDirection: 'column', alignItems: 'center', height: '100%', justifyContent: 'flex-end', cursor: 'pointer' }}
              onMouseEnter={() => setHoveredIndex(idx)}
              onMouseLeave={() => setHoveredIndex(null)}
            >
              <span style={{ fontSize: '0.74rem', fontWeight: 700, color: barColor, marginBottom: '4px' }}>
                {d.value}{isPercentage ? '%' : ''}
              </span>
              <div 
                style={{
                  width: '100%',
                  maxWidth: '38px',
                  height: `${barHeight}px`,
                  backgroundColor: barColor,
                  borderRadius: '4px 4px 0 0',
                  boxShadow: isHovered ? `0 4px 12px ${barColor}55` : 'none',
                  opacity: (hoveredIndex === null || isHovered) ? 1 : 0.65,
                  transform: isHovered ? 'scaleY(1.02)' : 'none',
                  transformOrigin: 'bottom',
                  transition: 'all 0.2s ease'
                }}
              />
              <span 
                style={{ 
                  fontSize: '0.72rem', 
                  color: isHovered ? 'var(--color-dark-navy)' : 'var(--text-secondary)', 
                  marginTop: '6px', 
                  textAlign: 'center', 
                  whiteSpace: 'nowrap', 
                  overflow: 'hidden', 
                  textOverflow: 'ellipsis', 
                  maxWidth: '75px', 
                  fontWeight: isHovered ? 700 : 500 
                }}
                title={d.label}
              >
                {d.label}
              </span>
            </div>
          );
        })}
      </div>
    );
  };

  // 2. Render Line Chart with Distinct Point Badges
  const renderLineChart = () => {
    const width = 450;
    const height = 160;
    const padding = 25;
    const count = normalizedData.length;

    const points = normalizedData.map((d, idx) => {
      const px = padding + (idx / Math.max(count - 1, 1)) * (width - 2 * padding);
      const py = height - padding - (d.value / maxValue) * (height - 2 * padding);
      return { ...d, x: px, y: py };
    });

    const pathData = points.reduce((acc, pt, idx) => `${acc} ${idx === 0 ? 'M' : 'L'} ${pt.x} ${pt.y}`, '');

    return (
      <div style={{ width: '100%', overflowX: 'auto' }}>
        <svg viewBox={`0 0 ${width} ${height}`} style={{ width: '100%', maxHeight: '200px' }}>
          <line x1={padding} y1={height - padding} x2={width - padding} y2={height - padding} stroke="var(--border-color)" strokeWidth="1" />
          
          {/* Main Trend Line */}
          <path d={pathData} fill="none" stroke="var(--color-primary-royal)" strokeWidth="2.5" strokeLinecap="round" />
          
          {/* Distinct Point Markers */}
          {points.map((pt, idx) => (
            <g key={idx}>
              <circle
                cx={pt.x}
                cy={pt.y}
                r={hoveredIndex === idx ? 6 : 4.5}
                fill={pt.color}
                stroke="#FFFFFF"
                strokeWidth="2"
                onMouseEnter={() => setHoveredIndex(idx)}
                onMouseLeave={() => setHoveredIndex(null)}
                style={{ cursor: 'pointer' }}
              />
              <text
                x={pt.x}
                y={pt.y - 8}
                textAnchor="middle"
                fontSize="10"
                fontWeight="700"
                fill={pt.color}
              >
                {pt.value}%
              </text>
              <text
                x={pt.x}
                y={height - 8}
                textAnchor="middle"
                fontSize="9"
                fill="var(--text-secondary)"
              >
                {pt.label}
              </text>
            </g>
          ))}
        </svg>
      </div>
    );
  };

  // 3. Render Donut / Pie Chart with Distinct Formal Color Slices & Legend
  const renderDonutChart = () => {
    const total = values.reduce((a, b) => a + b, 0) || 1;
    let accumulated = 0;
    const radius = 45;
    const circumference = 2 * Math.PI * radius;

    return (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', flexWrap: 'wrap', gap: '2.5rem', padding: '1.25rem 0' }}>
        <svg viewBox="0 0 120 120" style={{ width: '130px', height: '130px', transform: 'rotate(-90deg)' }}>
          {normalizedData.map((d, idx) => {
            const fraction = d.value / total;
            const strokeDash = fraction * circumference;
            const offset = (accumulated / total) * circumference;
            accumulated += d.value;
            const sliceColor = d.color;
            const isHovered = hoveredIndex === idx;
            
            return (
              <circle
                key={idx}
                cx="60"
                cy="60"
                r={radius}
                stroke={sliceColor}
                strokeWidth={isHovered ? 17 : 14}
                fill="none"
                strokeDasharray={`${strokeDash} ${circumference}`}
                strokeDashoffset={-offset}
                style={{ 
                  cursor: 'pointer',
                  opacity: (hoveredIndex === null || isHovered) ? 1 : 0.65,
                  transition: 'stroke-width 0.2s ease, opacity 0.2s ease'
                }}
                onMouseEnter={() => setHoveredIndex(idx)}
                onMouseLeave={() => setHoveredIndex(null)}
              />
            );
          })}
        </svg>

        {/* Distinct Legend Badges */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: '0.55rem', fontSize: '0.82rem' }}>
          {normalizedData.map((d, idx) => {
            const pct = Math.round((d.value / total) * 100);
            const isHovered = hoveredIndex === idx;
            return (
              <div 
                key={idx} 
                style={{ 
                  display: 'flex', 
                  alignItems: 'center', 
                  gap: '0.65rem',
                  padding: '3px 8px',
                  borderRadius: '4px',
                  backgroundColor: isHovered ? '#F0F4FC' : 'transparent',
                  cursor: 'pointer',
                  transition: 'background-color 0.15s ease'
                }}
                onMouseEnter={() => setHoveredIndex(idx)}
                onMouseLeave={() => setHoveredIndex(null)}
              >
                <span style={{ width: '10px', height: '10px', borderRadius: '3px', backgroundColor: d.color }} />
                <span style={{ color: 'var(--text-secondary)', fontWeight: 500 }}>{d.label}:</span>
                <strong style={{ color: d.color }}>{d.value}</strong>
                <span style={{ fontSize: '0.72rem', color: 'var(--text-secondary)', marginLeft: '2px' }}>({pct}%)</span>
              </div>
            );
          })}
        </div>
      </div>
    );
  };

  return (
    <div style={{ width: '100%', position: 'relative' }}>
      {title && (
        <div style={{ fontSize: '0.88rem', fontWeight: 700, color: 'var(--color-dark-navy)', marginBottom: '0.5rem' }}>
          {title}
        </div>
      )}

      {type === 'line' ? renderLineChart() : type === 'pie' || type === 'donut' ? renderDonutChart() : renderBarChart()}

      {(x_label || x_axis) && (
        <div style={{ textAlign: 'center', fontSize: '0.72rem', color: 'var(--text-secondary)', marginTop: '6px' }}>
          {x_label || x_axis}
        </div>
      )}
    </div>
  );
}
