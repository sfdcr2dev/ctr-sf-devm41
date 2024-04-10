trigger Account on Account (before insert) {
    AccountController.account();
}