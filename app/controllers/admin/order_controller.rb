class Admin::OrderController < ApplicationController  
  
    def index
        @orders = Order.all
      end
    
      def show
        @order = Order.find(params[:id])
        @order_items = @order.order_items
      end

      def update
        @order = Order.find(params[:id])
        if @order.status == 'shipped'
        @order.status = 'pending'
        elsif @order.status == 'pending'
        @order.status = 'shipped'
        end
        @order.save
        redirect_to admin_order_path(@order.id)
        end

end