module PaginationHelper
  extend Grape::API::Helpers

  # usage:
  #
  # params do
  #   use :pagination, default_per_page: 10, default_page: 2
  # end
  #
  # params do
  #   use :pagination
  # end
  params :pagination do |options|
    optional :per_page, type: Integer, default: options[:per_page] || APP_CONFIG['helpers']['pagination_helper']['per_page']['default']
    optional :page, type: Integer, default: options[:page] || APP_CONFIG['helpers']['pagination_helper']['page']['default']
  end
end
