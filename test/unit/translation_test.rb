require 'test_helper'

class TranslationTest < ActiveSupport::TestCase

  def setup
    Page.delete_all
  end

  def cleanup
    Page.delete_all
  end

  test "Page should store translations of title and body" do
    page = create_one_page(title: 'English', body: 'Fish n chips')
    page.translate!
    page.save
    page.reload
    assert page.t(:de,:title) == page.t(:en,:title), 'After translate! title should be the same in :de as in :en'
    page.t(:de,:title, 'Deutschland')
    page.t(:de,:body, 'Sauerkraut'  )
    page.save
    assert page.t(:en,:title) == page.title, 'Default locale should be equal model-field'
    assert page.t(:de,:title) == 'Deutschland', 'Locale :de should be Deutschland'
    assert page.t(:de,:body) == 'Sauerkraut',  'Germans should eat Sauerkraut'
  end

end
