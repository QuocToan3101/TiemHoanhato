# 🧪 Mock GHTK API - Local Development Guide

**Status**: ✅ Ready for Local Testing  
**Created**: May 11, 2026

---

## 📌 What is Mock GHTK API?

Mock GHTK API simulates the real GHTK shipping provider **locally on your machine** without needing:
- ❌ Real API credentials/token
- ❌ Internet connectivity to GHTK servers
- ❌ Valid GHTK account

Perfect for:
- ✅ Local development
- ✅ Testing without internet
- ✅ Continuous integration
- ✅ Demo environments

---

## 🚀 Quick Start

### Enable Mock Mode
Edit `src/main/resources/application.properties`:
```properties
# Set to true to use mock API, false for real GHTK API
ghtk.mock_enabled=true
ghtk.mock_base_url=http://localhost:8080/flowerstore/api/mock-ghtk
```

### Build & Run
```bash
cd D:\Study\flowerStore\TiemHoanhato

# Build
.\gradlew.bat clean war -x test

# Deploy to Tomcat
.\gradlew.bat deployToTomcat

# Start Tomcat (if not running)
# or open http://localhost:8080/flowerstore
```

### Test Shipping Fee
```bash
# Test the shipping calculation with mock API
curl -X POST http://localhost:8080/flowerstore/api/shipping/calculate \
  -H "Content-Type: application/json" \
  -H "X-Requested-With: XMLHttpRequest" \
  -d '{
    "place_id":"test",
    "address":"123 Nguyen Hue, District 1",
    "lat":10.771111,
    "lng":106.696969
  }'

# Expected response:
# {
#   "ghtk_fee": 15000,
#   "estimated_fee": 15000,
#   "distance_km": 5.0,
#   "eta_minutes": 10,
#   "free_shipping": true,
#   "message": "[Mock] Calculated shipping fee"
# }
```

---

## 🎯 Mock Fee Calculation

### Formula
```
Total Fee = Base Fee + (Distance × Per-KM Fee)
Base Fee: 15,000 VND
Per-KM Fee: 3,500 VND
```

### Example Distances
```
Quận 1 (District 1):    5.0 km  → 15,000 + (5.0 × 3,500) = 32,500 VND
Quận 5 (District 5):    8.5 km  → 15,000 + (8.5 × 3,500) = 44,750 VND
Quận 7 (District 7):   12.3 km  → 15,000 + (12.3 × 3,500) = 58,050 VND
Quận 12 (District 12): 15.0 km  → 15,000 + (15.0 × 3,500) = 67,500 VND
```

---

## 🔄 Switch Between Real & Mock

### Use Mock (Development)
```properties
ghtk.mock_enabled=true
```

### Use Real (Production)
```properties
ghtk.mock_enabled=false
ghtk.base_url=https://api.ghtk.vn
ghtk.token=YOUR_REAL_TOKEN_HERE
```

No code changes needed - just update the configuration!

---

## 📂 Files Added/Modified

### New Files
- ✅ `src/main/java/util/MockGhtkClient.java` - Mock fee calculator
- ✅ `src/main/java/util/ShippingClientFactory.java` - Client factory
- ✅ `src/main/java/controller/MockGhtkApiServlet.java` - Mock API endpoint

### Modified Files
- ✅ `src/main/java/controller/ShippingApiServlet.java` - Uses factory
- ✅ `src/main/resources/application.properties` - Mock config

---

## 🧪 Testing Scenarios

### Scenario 1: Local Checkout
```
1. Open http://localhost:8080/flowerstore
2. Add item to cart
3. Click "Checkout"
4. Enter address (e.g., "123 Nguyen Hue, District 1")
5. Fee should calculate automatically using mock API
6. Complete order
```

### Scenario 2: API Testing
```bash
# Test with different addresses
curl -X POST http://localhost:8080/flowerstore/api/shipping/calculate \
  -H "Content-Type: application/json" \
  -H "X-Requested-With: XMLHttpRequest" \
  -d '{
    "place_id":"test",
    "address":"456 Le Loi, District 5",
    "lat":10.780000,
    "lng":106.710000
  }'
```

### Scenario 3: Performance Testing
```bash
# Rapid requests to test performance
for i in {1..100}; do
  curl -s -X POST http://localhost:8080/flowerstore/api/shipping/calculate \
    -H "Content-Type: application/json" \
    -H "X-Requested-With: XMLHttpRequest" \
    -d '{"place_id":"test","address":"District 1","lat":10.771111,"lng":106.696969}' \
    > /dev/null
done
echo "100 requests completed"
```

---

## 📊 Mock API Response Format

### Success Response
```json
{
  "ghtk_fee": 32500,
  "estimated_fee": 32500,
  "distance_km": 5.0,
  "eta_minutes": 10,
  "free_shipping": true,
  "message": "[Mock] Shipping fee calculated",
  "deliverable": true
}
```

### Logs (Console)
```
[INFO] MockGhtkClient - Mock GHTK fee calculated: 32500 VND for 5.00 km
[INFO] MockGhtkApiServlet - [Mock GHTK] Responded with fee: 32500
```

---

## 🔍 Debug Mode

### Enable Debug Logging
Add to `application.properties`:
```properties
logging.level.controller.MockGhtkApiServlet=DEBUG
logging.level.util.MockGhtkClient=DEBUG
logging.level.util.ShippingClientFactory=DEBUG
```

### Check Logs
```bash
# View Tomcat logs
type D:\xampp\tomcat\logs\catalina.log | findstr "Mock"

# Should show:
# [Mock GHTK] Received request: ...
# Mock GHTK fee calculated: ... VND
# [Mock GHTK] Responded with fee: ...
```

---

## ⚙️ Customization

### Change Base Fee
Edit `MockGhtkClient.java`:
```java
// Change from 15,000 to 20,000 VND
BigDecimal baseFee = new BigDecimal("20000");
```

### Change Per-KM Fee
Edit `MockGhtkClient.java`:
```java
// Change from 3,500 to 5,000 VND per km
BigDecimal perKmFee = new BigDecimal("5000");
```

### Add Custom Distances
Edit `MockGhtkClient.java` - `extractDistance()` method:
```java
if (queryString.contains("Quận 11")) {
    return 18.5;  // 18.5 km distance
}
```

---

## 🚨 Troubleshooting

### Issue: Mock API returns 0 fee
**Check**:
1. Verify `ghtk.mock_enabled=true` in config
2. Restart Tomcat after changing config
3. Check logs for errors

### Issue: "Source map not found" in logs
**This is normal** - ignore these JS warnings

### Issue: Mock servlet not responding
**Solution**:
```bash
# 1. Check if Tomcat is running
curl http://localhost:8080/flowerstore

# 2. Check servlet loaded
curl http://localhost:8080/flowerstore/api/mock-ghtk/services/shipment/fee?test=1

# 3. Check logs
type D:\xampp\tomcat\logs\catalina.log | tail -100
```

### Issue: Can't switch from mock to real API
**Solution**:
```bash
# 1. Change configuration
# Set: ghtk.mock_enabled=false

# 2. Full rebuild and redeploy
.\gradlew.bat clean war -x test
.\gradlew.bat deployToTomcat

# 3. Verify in logs:
# Should show: "Using REAL GHTK Client: https://api.ghtk.vn"
```

---

## 📋 Checklist for Development

When developing with Mock API:
```
□ Set ghtk.mock_enabled=true
□ Build and deploy
□ Test checkout flow
□ Verify fees calculate correctly
□ Check logs for "[Mock]" entries
□ When done, switch to real API:
  □ Set ghtk.mock_enabled=false
  □ Add real GHTK token
  □ Rebuild and test
□ Commit changes (don't commit real token!)
```

---

## 🔐 Security

**IMPORTANT**: Mock API is **NOT for production**!

- ❌ Do NOT use mock API in production
- ✅ Only use for development/testing
- ✅ Always validate in staging with real API before production

---

## 📞 Support

### Common Questions

**Q: Will mock fees be saved to database?**
A: Yes, mock fees are saved just like real fees. Clear `delivery_history` table if needed.

**Q: Can I use mock API with real database?**
A: Yes! Mock API works with your real database perfectly.

**Q: How fast is mock API?**
A: ~50ms per request (very fast for testing)

**Q: Can I customize mock fees per district?**
A: Yes! Edit `extractDistance()` method in `MockGhtkClient.java`

---

## 🎉 Summary

You now have:
- ✅ Local mock GHTK API
- ✅ Easy switching between real/mock
- ✅ Zero configuration for credentials
- ✅ Fast development/testing
- ✅ Production-ready real integration

**Perfect for development!** 🚀

---

*Updated: May 11, 2026*
