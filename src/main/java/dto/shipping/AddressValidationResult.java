package dto.shipping;

public class AddressValidationResult {
    private boolean valid;
    private boolean vietnam;
    private boolean suspicious;
    private String message;
    private AddressSuggestion suggestion;

    public boolean isValid() { return valid; }
    public void setValid(boolean valid) { this.valid = valid; }
    public boolean isVietnam() { return vietnam; }
    public void setVietnam(boolean vietnam) { this.vietnam = vietnam; }
    public boolean isSuspicious() { return suspicious; }
    public void setSuspicious(boolean suspicious) { this.suspicious = suspicious; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public AddressSuggestion getSuggestion() { return suggestion; }
    public void setSuggestion(AddressSuggestion suggestion) { this.suggestion = suggestion; }
}
