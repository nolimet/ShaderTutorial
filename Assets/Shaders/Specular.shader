Shader "Custom/Specular - vertex" {
	Properties{
		_Color  ("Color", Color ) = (1.0,1.0,1.0,1.0)
		_SpecColor ("Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininees", Float) = 10
	}
	SubShader {
		
			Tags{"ligthMode" = "forwardBase"}
			
			Pass{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				
				//userDif
				uniform float4 _Color;
				uniform float4 _SpecColor;
				uniform float _Shininess;
				
				//unityvars
				uniform float4 _LightColor0;
				
				//structs
				struct vertexInput{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					};
					
				struct vertexOutput{
					float4 pos : SV_POSITION;
					float4 col : COLOR;
				};
				
				vertexOutput vert(vertexInput v){
					vertexOutput o;
					
					//vectors
					float3 normalDirection = normalize(mul( float4(v.normal,0.0), _World2Object).xyz);
					float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz,1.0) - mul(UNITY_MATRIX_MVP, v.vertex).xyz));
					float3 lightDirection;
					float atten = 1.0;
					
					//lighting
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
					float3 diffuseReflection = atten * _LightColor0.xyz  * max(0.0,dot(normalDirection, lightDirection));
					float3 specularReflection = max(0.0,dot(normalDirection, lightDirection) * pow( max(0.0,dot(reflect(-lightDirection, normalDirection), viewDirection)),_Shininess));
					
					o.col = float4(specularReflection,1.0);
					o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
					return o;
				}
				
				float4 frag(vertexOutput i) : COLOR
				{
					return i.col;
				}
				
				ENDCG
	} 
	
	//FallBack "Diffuse"
}
}