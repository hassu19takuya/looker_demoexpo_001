view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  parameter: period_granularity {
    label: "日付粒度の選択"
    description: "グラフの集計単位の選択が可能にするセレクター"
    type: unquoted
    allowed_value: {
      label: "年"
      value: "year"
    }
    allowed_value: {
      label: "月"
      value: "month"
    }
    allowed_value: {
      label: "日"
      value: "day"
    }
  }

  dimension: aggrigate_period {
    label_from_parameter: period_granularity
    label: "集計粒度"
    sql:
    {% if period_granularity._parameter_value == 'year' %}
        ${created_year}
    {% elsif period_granularity._parameter_value == 'month' %}
        ${created_month}
    {% elsif period_granularity._parameter_value == 'day' %}
        ${created_date}
    {% endif %};;
  }

  parameter: measure_selector{
    label: "KPIの変更"
    description: "グラフに表示されるKPIを変更する"
    type: unquoted
    allowed_value: {
      label: "売上"
      value: "sales"
    }
    allowed_value: {
      label: "オーダー数"
      value: "order"
    }
    allowed_value: {
      label: "顧客数"
      value: "users"
    }
  }

  measure: selected_measure {
    label_from_parameter: measure_selector
    label: "KPI"
    type: number
    sql:
    {% if measure_selector._parameter_value == 'sales' %}
        ${total_sale_price}
    {% elsif measure_selector._parameter_value == 'order' %}
        ${total_order_num}
    {% elsif measure_selector._parameter_value == 'users' %}
        ${uu}
    {% else %}
        0
    {% endif %};;
  }


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
    hidden: yes
  }

  dimension_group: created {
    label: "受注日"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    label: "配達日"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  measure: total_order_num {
    label: "オーダー数"
    type: count_distinct
    sql: ${order_id} ;;
  }

  dimension_group: returned {
    label: "返却日"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    label: "売上額"
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  measure: total_sale_price {
    label: "総売上額"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  dimension_group: shipped {
    label: "出荷日"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    label: "受注ステータス"
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: uu {
    label: "購入者数"
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
}
