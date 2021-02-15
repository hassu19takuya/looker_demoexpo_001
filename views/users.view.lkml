view: users {
  sql_table_name: "PUBLIC"."USERS"
    ;;
  drill_fields: [id]

  parameter: dimension_selector{
    label: "分析軸の変更"
    description: "グラフの分析軸を変更する"
    type: unquoted
    allowed_value: {
      label: "年齢層"
      value: "age_tier"
    }
    allowed_value: {
      label: "性別"
      value: "gender"
    }
    allowed_value: {
      label: "居住地"
      value: "state"
    }
  }

  dimension: selected_dimension {
    label: "選択式分析軸"
    description: "分析軸を年齢層、性別、居住地から選択してグラフを変更することが可能"
    type: string
    sql:
    {% if dimension_selector._parameter_value == 'age_tier' %}
      ${age_tier}
    {% elsif dimension_selector._parameter_value == 'gender' %}
      ${gender_jp}
    {% elsif dimension_selector._parameter_value == 'state' %}
      ${state}
    {% else %}
      null
    {% endif %};;


  }

  ### 基礎のテーブル定義情報 ###
  dimension: id {

    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: age {
    label: "年齢"
    type: number
    sql: ${TABLE}."AGE" ;;
  }

  dimension: age_tier {
    label: "年齢層"
    type: tier
    tiers: [10,20,30,40,50,60,70,80]
    style: integer
    sql: ${age} ;;
  }

  dimension: city {
    label: "市区町村"
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: country {
    label: "国"
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }

  dimension_group: created {
    label: "ユーザー登録日時"
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

  dimension: email {
    label: "Eメール"
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    hidden: yes
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: gender {
    hidden: yes
    type: string
    sql: ${TABLE}."GENDER" ;;
  }

  dimension: gender_jp{
    label: "性別"
    type: string
    sql: case when ${gender} like 'Male' then '男性'
          when ${gender} like 'Female' then '女性'
          else 'その他'
          end;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: name {
    label: "ユーザー"
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }
}
