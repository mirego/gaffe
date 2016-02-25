module Gaffe
  module Errors
    extend ActiveSupport::Concern

    included do
      before_action :fetch_exception, only: %w(show)
      before_action :append_view_paths
      layout 'error'
    end

    def show
      render "errors/#{@rescue_response}", status: @status_code
    rescue ActionView::MissingTemplate
      render 'errors/internal_server_error', status: 500
    end

  protected

    def fetch_exception
      @exception = request.env['action_dispatch.exception']
      @status_code = ActionDispatch::ExceptionWrapper.new(request.env, @exception).status_code
      @rescue_response = ActionDispatch::ExceptionWrapper.rescue_responses[@exception.class.name]
    end

  private

    def append_view_paths
      append_view_path Gaffe.root.join('app/views')
    end
  end
end
