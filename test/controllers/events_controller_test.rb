require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post events_url, params: { event: { comment_count: @event.comment_count, content: @event.content, end_date: @event.end_date, event_category_id: @event.event_category_id, event_time: @event.event_time, event_type_id: @event.event_type_id, start_date: @event.start_date, status: @event.status, title: @event.title, user_id: @event.user_id, view_count: @event.view_count } }
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: { comment_count: @event.comment_count, content: @event.content, end_date: @event.end_date, event_category_id: @event.event_category_id, event_time: @event.event_time, event_type_id: @event.event_type_id, start_date: @event.start_date, status: @event.status, title: @event.title, user_id: @event.user_id, view_count: @event.view_count } }
    assert_redirected_to event_url(@event)
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end
end
