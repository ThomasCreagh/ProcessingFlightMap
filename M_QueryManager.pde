//CKM: code to return details about airports

class QueryManagerClass {

  Table m_airportTable;
  Table m_usaAirportIndexes;
  TableRow m_lookupResult;

  void init() {
    m_airportTable = loadTable("data/Preprocessed Data/airports.csv", "header");
    m_usaAirportIndexes = loadTable("data/Preprocessed Data/airport_lookup_table.csv");
  }

  float getLatitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat("Latitude");
  }
  float getLongitude(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getFloat(5);
  }
  String getAirportName(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Name");
  }
  String getCity(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("City");
  }
  String getCountry(String code) {
    m_lookupResult = m_airportTable.findRow(code, "IATA");
    return m_lookupResult.getString("Country");
  }
  String getCode(int index) {
    m_lookupResult = m_usaAirportIndexes.findRow(String.valueOf(index), 1);
    return m_lookupResult.getString(0);
  }
}