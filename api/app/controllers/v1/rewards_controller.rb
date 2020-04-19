class V1::RewardsController < ApplicationController
  # def index
  #   if params[:uid] 
  #     user = User.find_by(uid: params[:uid])
  #     todos = user.todos.order(sort: "ASC")
  #     render json: {user: user, todos: todos}
  #   else 
  #     @users = User.all
  #     render json: @users
  #   end
  # end

    def create
      reward = Reward.new(reward_params)
      if reward.save
        render json: reward, status: :created
      else
        if reward.errors.present?
          render json: {error_msg: reward.errors.full_messages}, status: :unprocessable_entity
        else 
          render json: reward.errors, status: :unprocessable_entity
        end
      end
    end

    def update
      reward = Reward.find(params[:id])
      # binding.pry
      reward.update(reward_params)
      render json: reward
    end

    def destroy
      reward = Reward.find(params[:id])
      if reward.destroy
        render json: reward
      end
    end

    def complete
      reward = Reward.find(params[:id])
      # binding.pry
      reward.update(status: true)
      user = User.find(reward.user_id)
      losepoint = user.point.to_i
      losepoint -= reward.point
      user.point = losepoint
      user.update(point: losepoint)
      # ポイントを加算to_iはいずれ消す
      # なぜかキャッシュから読み込むから変数に入れる
      render json: {reward: reward, user: user}
    end

    def sort
      params[:reward].each_with_index do |t,i|
        @reward = Reward.find(t[:id])
        @reward.update( sort: i )
      end
      render json: {result: "ok"}
    end

    private
      def reward_params
        params.require(:reward).permit(:title, :user_id, :point, :status, :sort)
      end
end
