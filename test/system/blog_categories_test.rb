require "application_system_test_case"

class BlogCategoriesTest < ApplicationSystemTestCase
  setup do
    @blog_category = blog_categories(:one)
  end

  test "visiting the index" do
    visit blog_categories_url
    assert_selector "h1", text: "Blog Categories"
  end

  test "creating a Blog category" do
    visit blog_categories_url
    click_on "New Blog Category"

    fill_in "Name", with: @blog_category.name
    click_on "Create Blog category"

    assert_text "Blog category was successfully created"
    click_on "Back"
  end

  test "updating a Blog category" do
    visit blog_categories_url
    click_on "Edit", match: :first

    fill_in "Name", with: @blog_category.name
    click_on "Update Blog category"

    assert_text "Blog category was successfully updated"
    click_on "Back"
  end

  test "destroying a Blog category" do
    visit blog_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Blog category was successfully destroyed"
  end
end
