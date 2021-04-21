connection: "snowlooker"
label: "Huskyデモ モデル"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: retail_analytics {
  label: "オーダー分析"
  view_name: order_items
  view_label: "オーダー情報"

  always_filter: {
    filters: {
      field: created_date
      value: "last 90 days"
    }
  }

  access_filter: {
    field: inventory_items.product_brand
    user_attribute: product_brand
  }

  join: user_info {
    view_label: "ユーザー情報"
    from: users
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${user_info.id} ;;
  }

  join: inventory_items {
    relationship: many_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }

  join: products {
    relationship: many_to_one
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
  }

}
