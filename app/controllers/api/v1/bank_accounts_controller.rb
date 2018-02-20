module Api
  module V1
    class BankAccountsController < ActionController::Base
      before_action :set_bank_account, only: [:balance, :show]

      def index
        @bank_accounts = BankAccount.all
        render json: { bank_accounts: @bank_accounts.map { |i| { username: i.username, id: i.id } } }
      end

      def show
        render json: { username: @bank_account.username, id: @bank_account.id }
      end

      def balance
        render json: { balance: @bank_account.balance }
      end

      def create
        @bank_account = BankAccount.new(bank_account_params)

        if @bank_account.save
          render json: { status: :ok }
        else
          render json: { error_description: @bank_account.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      private
      def set_bank_account
        @bank_account = BankAccount.find(params[:id])
      end

      def bank_account_params
        params.require(:bank_account).permit(:username)
      end
    end
  end
end

