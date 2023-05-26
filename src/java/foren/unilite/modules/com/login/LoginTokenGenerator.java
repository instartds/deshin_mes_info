package foren.unilite.modules.com.login;
import java.io.File;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
//import java.util.Base64;
import java.util.Date;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.configuration.XMLConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import foren.framework.utils.ConfigUtil;
import foren.framework.utils.ObjUtils;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

/**
 * <pre>
 * 참조 : https://stormpath.com/blog/jwt-java-create-verify
 * 
 * jjwt-0.6.0.jar 
 * jackson-annotation 
 * jackson-core 
 * jackson-databind
 * </pre>
 * 
 * @author Administrator
 *
 */
public class LoginTokenGenerator {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	// Sample method to construct a JWT
    /**
     * 
     * @param id
     * @param issuer
     * @param subject
     * @param ttlMillis 만료기간 - millisecond ( 0 이면 무한 )
     * @return
     */
	public static String createJWT(String id, String issuer, String subject, long ttlMillis) throws Exception {
		
		// The JWT signature algorithm we will be using to sign the token
		SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;

		long nowMillis = System.currentTimeMillis();
		Date now = new Date(nowMillis);

		XMLConfiguration key = new XMLConfiguration(ConfigUtil.getProperty("common.login.keyPath").toString()+File.separatorChar+"connectKey.xml");
			
		String secKey = ObjUtils.getSafeString(key.getProperty("connectKey"));

		byte[] apiKeySecretBytes = DatatypeConverter.parseBase64Binary(secKey);
		Key signingKey = new SecretKeySpec(apiKeySecretBytes, signatureAlgorithm.getJcaName());

		// Let's set the JWT Claims
		JwtBuilder builder = Jwts.builder().setId(id).setIssuedAt(now).setSubject(subject).setIssuer(issuer)
				.signWith(signatureAlgorithm, signingKey);

		// if it has been specified, let's add the expiration
		if (ttlMillis >= 0) {
			long expMillis = nowMillis + ttlMillis;
			Date exp = new Date(expMillis);
			builder.setExpiration(exp);
		}

		// Builds the JWT and serializes it to a compact, URL-safe string
		return builder.compact();
	}

	// Sample method to validate and read the JWT
	public static Claims parseJWT(String token) throws Exception {
		// This line will throw an exception if it is not a signed JWS (as
		// expected)

		XMLConfiguration key = new XMLConfiguration(ConfigUtil.getProperty("common.login.keyPath").toString()+File.separatorChar+"connectKey.xml");
			
		String secKey = ObjUtils.getSafeString(key.getProperty("connectKey"));
		Claims claims = Jwts.parser().setSigningKey(DatatypeConverter.parseBase64Binary(secKey))
				.parseClaimsJws(token).getBody();
		System.out.println("ID: " + claims.getId());
		System.out.println("Subject: " + claims.getSubject());
		System.out.println("Issuer: " + claims.getIssuer());
		System.out.println("Expiration: " + claims.getExpiration());
		
		return claims;
	}
/*
	private String getSecretKey() {
		// create new key
		SecretKey secretKey = null;
		try {
			secretKey = KeyGenerator.getInstance("AES").generateKey();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		// get base64 encoded version of the key
		return null ;//Base64.getEncoder().encodeToString(secretKey.getEncoded());
	}
*/
}

