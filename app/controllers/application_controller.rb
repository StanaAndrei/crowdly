class ApplicationController < ActionController::Base
    include SessionsHelper

    def hello
        render html: "hi world"
    end
end
