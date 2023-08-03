public with sharing class RevchainXML {
	
	
	public static string Customer(Account cuenta){
		
		string xml='';
		xml='<Customer>'
			+'<FirstName>'+cuenta.Name+'</FirstName>'
			+'<Surname></Surname>'
			+'<FullName>'+cuenta.Name+'</FullName>'
			+'<ContactInfo>'
			+'	<FirstName/>'
			+'	<LastName/>'
			+'	<PhoneNumber/>'
			+'	<ContactAddress>'
			+'		<LineOne></LineOne>'
			+'		<CityName></CityName>'
			+'		<StateName></StateName>'
			+'		<CountryCode/>'
			+'		<CountryName></CountryName>'
			+'		<GisID></GisID>'
			+'		<Latitude></Latitude>'
			+'		<Longitude></Longitude>'
			+'		<CityCode></CityCode>'
			+'		<StateCode></StateCode>'
			+'		<PurposeCode></PurposeCode>'
			+'		<Technology>'
			+'			<Type></Type>'
			+'			<CoverageType></CoverageType>'
			+'			<CoverageIndicator></CoverageIndicator>'
			+'			<CoverageName></CoverageName>'
			+'			<Zone></Zone>'
			+'		</Technology>'
			+'		<DaneCode></DaneCode>'
			+'		<Postcode></Postcode>'
			+'		<GeoGroup></GeoGroup>'
			+'	</ContactAddress>'
			+'</ContactInfo>'
			+'<MarketType></MarketType>'
			+'<DocumentType></DocumentType>'
			+'<DocumentNo></DocumentNo>'
			+'</Customer>';
			
		return xml;
	}
	

}