class Api::V1::RecordsController < Api::V1::ApiController
  include RecordsHelper

  before_action :set_record

  def vote
    if @record.update(vote_params)
      head :ok
    else
      head :bad_request
    end
  end

  def attack
    if @record.update(attack_params)
      @record.village.post_system_message_for_wolf(attack_target_set_message(@record))
      head :ok
    else
      head :bad_request
    end
  end

  def divine
    if @record.update(divine_params)
      head :ok
    else
      head :bad_request
    end
  end

  def guard
    if @record.update(guard_params)
      head :ok
    else
      head :bad_request
    end
  end

  private

  def set_record
    @record = Record.find(params[:id])
    authorize @record
  end

  def vote_params
    params.require(:record).permit(:vote_target_id)
  end

  def attack_params
    params.require(:record).permit(:attack_target_id)
  end

  def divine_params
    params.require(:record).permit(:divine_target_id)
  end

  def guard_params
    params.require(:record).permit(:guard_target_id)
  end
end
