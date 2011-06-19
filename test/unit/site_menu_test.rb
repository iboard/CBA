require 'test_helper'

class SiteMenuTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "SiteMenue should be a tree" do
    root_1 = SiteMenu.create name:'Root 1'
    child_1= SiteMenu.create name:'Child in R1'
    child_2= SiteMenu.create name:'Child in R1'
    root_1.children << [child_1, child_2]
    root_1.save
    root_1.reload
    assert root_1.children.count == 2, 'Should have two children'
  end

  test "SiteMenu name should not be empty" do
    root_1 = SiteMenu.create name:''
    assert !root_1.save, 'Site menu should not save without a name'
  end
end
