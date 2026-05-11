# 🔄 Quick Switch: Real vs Mock GHTK API

## 📋 For Development (Use Mock)

Edit: `src/main/resources/application.properties`

```properties
# Set MOCK mode ON
ghtk.mock_enabled=true
ghtk.mock_base_url=http://localhost:8080/flowerstore/api/mock-ghtk

# Real API (ignored when mock is enabled)
ghtk.base_url=https://api.ghtk.vn
ghtk.token=0767e825-4b9a-11f1-a973-aee5264794df
```

Then:
```bash
.\gradlew.bat clean war -x test
.\gradlew.bat deployToTomcat
```

**Result**: Shipping fees calculated by mock API locally ✅

---

## 🚀 For Production (Use Real)

Edit: `src/main/resources/application.properties`

```properties
# Set MOCK mode OFF
ghtk.mock_enabled=false
ghtk.mock_base_url=http://localhost:8080/flowerstore/api/mock-ghtk

# Real API (active now)
ghtk.base_url=https://api.ghtk.vn
ghtk.token=0767e825-4b9a-11f1-a973-aee5264794df  # Use real token
```

Then:
```bash
.\gradlew.bat clean war -x test
.\gradlew.bat deployToTomcat
```

**Result**: Shipping fees calculated by real GHTK API ✅

---

## 🔍 Verify Which Mode

Check logs:
```
✅ Mock mode:
  "Using MOCK GHTK Client for local development/testing"

✅ Real mode:
  "Using REAL GHTK Client: https://api.ghtk.vn"
```

---

## 📂 3 Files Handle Everything

1. **MockGhtkClient.java** - Calculates mock fees
2. **ShippingClientFactory.java** - Decides which client to use
3. **application.properties** - Controls the switch

No other changes needed! Just change the config. 🎯
