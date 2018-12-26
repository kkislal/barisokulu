require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "creating a Event" do
    visit events_url
    click_on "New Event"

    fill_in "Comment Count", with: @event.comment_count
    fill_in "Content", with: @event.content
    fill_in "End Date", with: @event.end_date
    fill_in "Event Category", with: @event.event_category_id
    fill_in "Event Time", with: @event.event_time
    fill_in "Event Type", with: @event.event_type_id
    fill_in "Start Date", with: @event.start_date
    fill_in "Status", with: @event.status
    fill_in "Title", with: @event.title
    fill_in "User", with: @event.user_id
    fill_in "View Count", with: @event.view_count
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "updating a Event" do
    visit events_url
    click_on "Edit", match: :first

    fill_in "Comment Count", with: @event.comment_count
    fill_in "Content", with: @event.content
    fill_in "End Date", with: @event.end_date
    fill_in "Event Category", with: @event.event_category_id
    fill_in "Event Time", with: @event.event_time
    fill_in "Event Type", with: @event.event_type_id
    fill_in "Start Date", with: @event.start_date
    fill_in "Status", with: @event.status
    fill_in "Title", with: @event.title
    fill_in "User", with: @event.user_id
    fill_in "View Count", with: @event.view_count
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "destroying a Event" do
    visit events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Event was successfully destroyed"
  end
end
