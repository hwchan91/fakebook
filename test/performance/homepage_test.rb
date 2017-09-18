require 'test_helper'
require 'rails/performance_test_help'

class HomepageTest < ActionDispatch::PerformanceTest
  include Devise::Test::IntegrationHelpers

  # Refer to the documentation for all available options
   self.profile_options = { runs: 5, metrics: [:wall_time, :memory, :objects, :gc_runs, :gc_time] }


  def setup 
    @michael = users(:michael)
    sign_in @michael
  end

  def test_homepage
    get root_path
  end
end
