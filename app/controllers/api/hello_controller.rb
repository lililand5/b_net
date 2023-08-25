module Api
  class HelloController < ApplicationController
    def index
      render json: { hi: "hi" }
    end
  end
end
