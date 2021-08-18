view: loop_parameter {
  derived_table: {
    sql:
    {% assign count = 0 %}
    SELECT
    {% if loop_parameter.inventory_item_id._is_selected %}
      {% if count > 0 %}
        ,
      {% endif %}
      "INVENTORY_ITEM_ID"
      {% assign count = count | plus: 1 %}
    {% endif %}
    {% if loop_parameter.order_id._is_selected %}
      {% if count > 0 %}
        ,
      {% endif %}
      "ORDER_ID"
      {% assign count = count | plus: 1 %}
    {% endif %}
    , 'Order Num' as KPI
    ,count(*) as value
    FROM "PUBLIC"."ORDER_ITEMS"
    {% assign group_count = 0 %}
    group by
    {% if loop_parameter.inventory_item_id._is_selected %}
      {% if group_count > 0 %}
        ,
      {% endif %}
      "INVENTORY_ITEM_ID"
      {% assign group_count = group_count | plus: 1 %}
    {% endif %}
    {% if loop_parameter.order_id._is_selected %}
      {% if group_count > 0 %}
        ,
      {% endif %}
      "ORDER_ID"
      {% assign group_count = group_count | plus: 1 %}
    {% endif %}
      ;;
  }

  parameter: table_name {
    type: unquoted
  }

  measure: count {
    type: count
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
    hidden: yes
  }

  dimension: inventory_item_id {
    type: number
    hidden: no
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension: kpi {
    type: string
    sql: ${TABLE}.kpi ;;
  }

  measure: value {
    type: sum
    sql: ${TABLE}.value ;;
  }


}
