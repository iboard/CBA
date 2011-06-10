require 'test_helper'

class SiteMenuTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "SiteMenue should be a tree" do
    root_1 = SiteMenu.create label:'Root 1'
    child_1= SiteMenu.create label:'Child in R1'
    child_2= SiteMenu.create label:'Child in R1'
    root_1.children << [child_1, child_2]
    root_1.save
    root_1.reload
    assert root_1.children.count == 2, 'Should have two children'
  end
end
