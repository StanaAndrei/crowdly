class ApplicationController < ActionController::Base
    def hello
        render html: "hi world"
    end
end
