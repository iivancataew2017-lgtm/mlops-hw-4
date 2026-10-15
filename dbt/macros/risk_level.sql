{% macro risk_level(column) -%}
case
    when {{ column }} >= {{ var('high_risk_rate') }} then 'HIGH'
    when {{ column }} >= {{ var('medium_risk_rate') }} then 'MEDIUM'
    else 'LOW'
end
{%- endmacro %}
