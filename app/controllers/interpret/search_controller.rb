class Interpret::SearchController < Interpret::BaseController
  before_filter { authorize! :use, :search }

  def index
    if request.post?
      opts = {}
      opts[:key] = params[:key] if params[:key].present?
      opts[:value] = params[:value] if params[:value].present?
      redirect_to search_url(opts)
    else
      if params[:key].present? || params[:value].present?
        sanitizer = case ActiveRecord::Base.connection.adapter_name
                    when 'SQLite'
                      if Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new('1.9')
                        ->(x) { "%#{x}%" }
                      else
                        ->(x) { "%#{CGI.escape(x)}%" }
                      end
                    else
                      ->(x) { "%#{CGI.escape(x)}%" }
                    end
        t = Interpret::Translation.arel_table
        search_key = params[:key].present? ? params[:key].split(' ').map { |x| sanitizer.call(x) } : []
        search_value = params[:value].present? ? params[:value].split(' ').map { |x| sanitizer.call(x) } : []
        if search_value.any? && search_key.any?
          @translations = Interpret::Translation.allowed.locale(I18n.locale).where(t[:key].matches_all(search_key).or(t[:value].matches_all(search_value))).order('translations.key ASC')
        elsif search_key.any?
          @translations = Interpret::Translation.allowed.locale(I18n.locale).where(t[:key].matches_all(search_key)).order('translations.key ASC')
        else
          @translations = Interpret::Translation.allowed.locale(I18n.locale).where(t[:value].matches_all(search_value)).order('translations.key ASC')
        end
      end
    end
  end
end
