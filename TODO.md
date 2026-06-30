# SDGVS Backend-Frontend Connection TODO

## Status: ✅ Port Fixed | ✅ agriculture_api Complete (GET only)

### 1. [x] Fix API Client Port ✓
### 2. [x] Complete agriculture_api.dart ✓ 
### 3. [ ] Start Backend Server
   ```bash
   cd sdgvs-backend && npm install && node server.js
   ```
   - Verify: http://10.131.88.40:5000/api/crop-calendar

### 4. [ ] Flutter Test
   ```bash
   flutter pub get && flutter run
   ```
   - Navigate: Login → Home → Agriculture → Farmer Advisory/Crop Calendar/Mandi

### 5. [ ] ✅ Complete
   - Agriculture/auth connected to backend DB via GET
   - Ready for production
