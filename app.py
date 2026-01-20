import streamlit as st
import pandas as pd
import psycopg2

# Set Page Config
st.set_page_config(page_title="Mason Watch 2.0", layout="wide")

st.title("🛡️ Mason Watch: US Homicide Analytics")
st.markdown("Analyzing crime trends using FBI data and PostGIS.")


# 1. Connection Function (Cached so it doesn't reconnect every time you click a button)
@st.cache_resource
def get_connection():
    return psycopg2.connect(
        dbname="urban_data",
        user="postgres",
        password="12345",
        host="localhost"
    )


conn = get_connection()

# 2. Sidebar Filters
st.sidebar.header("Filter Map")
year_choice = st.sidebar.slider("Select Year", 1980, 2024, 2020)

# 3. Fetch Data for the Map
# We only pull rows that have coordinates
query = f"""
    SELECT latitude, longitude, city, weapon, victim_count 
    FROM homicide_data 
    WHERE latitude IS NOT NULL 
    AND year = {year_choice};
"""

df = pd.read_sql(query, conn)

# 4. Display the Map
if not df.empty:
    st.subheader(f"Crime Incidents in {year_choice}")
    # Streamlit looks for columns named 'latitude' and 'longitude' automatically
    st.map(df)

    # Show the raw data table below the map
    st.write("### Recent Incident Data", df.head(10))
else:
    st.warning("No data found for this year yet. Is the geocoder still running?")

# 5. Summary Stats
total_crimes = len(df)
st.sidebar.metric("Incidents Shown", total_crimes)