abstract class FriendRepository {
  void sendRequest(String userId);
  void acceptRequest(String userId);
  void rejectRequest(String userId);
  void unfriend(String userId);
}
