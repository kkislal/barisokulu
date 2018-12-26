require "application_system_test_case"

class EventCategoriesTest < ApplicationSystemTestCase
  setup do
    @event_category = event_categories(:one)
  end

  test "visiting the index" do
    visit event_categories_url
    assert_selector "h1", text: "Event Categories"
  end

  test "creating a Event category" do
    visit event_categories_url
    click_on "New Event Category"

    fill_in "Name", with: @event_category.name
    click_on "Create Event category"

    assert_text "Event category was successfully created"
    click_on "Back"
  end

  test "updating a Event category" do
    visit event_categories_url
    click_on "Edit", match: :first

    fill_in "Name", with: @event_category.name
    click_on "Update Event category"

    assert_text "Event category was successfully updated"
    click_on "Back"
  end

  test "destroying a Event category" do
    visit event_categories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Event category was successfully destroyed"
  end
end
