class WhouseElementsController < ApplicationController
  before_action :logged_in_user

  # GET /whouses
  # GET /whouses.json
  def index
    @whouses = Whouse.all
    if params[:search]
      @whels = WhouseElement.joins(:element).where('elements.name LIKE ?', '%'+ params[:search]+'%').order(:whouse_id)
    else
      @whels = WhouseElement.order(:whouse_id)
    end
  end


  # GET /whouses/1/edit
  def edit
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def whel_params
      params.require(:whouse_id,:element_id).permit(:name)
    end
end
