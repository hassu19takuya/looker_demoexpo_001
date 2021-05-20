connection: "snowlooker"

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

explore: inherit1 {
  view_name: inventory_items
  # view_label: "中間製品"

  join: order_items {
    relationship: one_to_many
    sql: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }
}

explore: inherit2 {
  label: "継承1"
  extends: [inherit1]
  view_label: "製品"

  join: products {
    view_label: "製品"
    relationship: one_to_one
    sql: ${inventory_items.product_id} = ${products.id} ;;
  }
}

explore: expose {
  label: "孫継承1"
  extends: [inherit2]

  join: users {
    relationship: many_to_one
    sql: ${order_items.user_id} = ${users.id} ;;
  }
}
