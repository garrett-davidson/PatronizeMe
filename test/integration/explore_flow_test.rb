require 'test_helper'

class ExploreFlowTest < ActionDispatch::IntegrationTest
  test 'sorted by recent' do
    get '/explore.json?sort=recent'
    results = ActiveSupport::JSON.decode(@response.body).map { |x| Project.find(x['id']) }
    assert_collection_sorted_desc results, :created_at
    assert_response :success
  end
end
