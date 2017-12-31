class Api::V1::VillagesController < Api::V1::ApiController
  before_action :set_village

  def remaining_time
    render json: {remaining_time: @village.remaining_time}, status: 200
  end

  def divine
    render json: {messages: view_context.messages_of_result(@village.divine_results)}, status: 200
  end

  def see_soul
    render json: {messages: view_context.messages_of_result(@village.vote_results)}, status: 200
  end

  private

  def set_village
    @village = Village.find(params[:id])
    authorize @village
  end
end
