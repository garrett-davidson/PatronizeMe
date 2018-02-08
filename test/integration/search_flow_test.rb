# frozen_string_literal: true

require 'test_helper'

class SearchFlowTest < ActionDispatch::IntegrationTest
  def results_for_query(query)
    get '/search.json', params: { q: query }
    ActiveSupport::JSON.decode @response.body
  end

  test 'search title json' do
    results = results_for_query 'pat'
    assert_equal results.count, 1, 'Incorrect number of results: ' + results.count.to_s
    assert_response :success
  end

  test 'search for multiple json' do
    results = results_for_query 'a'
    assert_equal results.count, 2, 'Incorrect number of results: ' + results.count.to_s
    assert_response :success
  end

  test 'search for gibberish json' do
    results = results_for_query 'fghetrag'
    assert_equal results.count, 0, 'Returned results that should not have matched'
    assert_response :success
  end

  test 'search description json' do
    results = results_for_query 'awesome'
    assert_equal results.count, 2, 'Incorrect number of results: ' + results.count.to_s
    assert_response :success
  end

  test 'empty search json' do
    get '/search.json', params: { q: '' }
    assert_redirected_to '/explore'
  end

  test 'no search query json' do
    get '/search.json'
    assert_redirected_to '/explore'
  end

  test 'sorted search results' do
    results = results_for_query('a').map { |x| Project.find(x['id']) }
    assert_collection_sorted_desc results, :total_funding
    assert_response :success
  end
end
