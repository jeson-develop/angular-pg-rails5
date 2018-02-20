module Api
  module V1
    class TransactionsController < ActionController::Base
      before_action :set_bank_account

      def index
        ts = @bank_account.transactions
                 .where(params[:start_date].present? ? ["date(created_at) >= ?", params[:start_date]] : [])
                 .where(params[:end_date].present? ? ["date(created_at) <= ?", params[:end_date]] : [] )
                 .where(params[:delete].present? ? ["id != ?", params[:delete]] : [] )
                 .order(id: :desc)
        render json: { transactions: ts.map { |i|
          { amount: i.amount || 0, amount_status: i.amount_status, state: i.state_to_s, date: i.created_at.strftime("%F %R") }
        }, status: :ok }
      end

      def create
        ba = BankAccount.find_by_id(params[:creditor_id])
        transaction = @bank_account.transaction(params[:state].to_i, params[:amount], ba)
        if transaction
          render json: { status: :ok, message: @bank_account.transactions.last.success_message }
        else
          render json: { error_description: @bank_account.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      private
      def set_bank_account
        @bank_account = BankAccount.find(params[:bank_account_id])
      end

      # def transaction_params
      #   params.require(:transaction).permit(:state, :amount)
      # end
    end
  end
end
