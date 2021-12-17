package org.ztv.anmeldetool.anmeldetool.config;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.autoconfigure.security.SecurityProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.BeanIds;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.DelegatingPasswordEncoder;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.crypto.password.Pbkdf2PasswordEncoder;
import org.springframework.security.crypto.password.StandardPasswordEncoder;
import org.springframework.security.crypto.scrypt.SCryptPasswordEncoder;

@Configuration
@EnableWebSecurity
@Order(SecurityProperties.BASIC_AUTH_ORDER)
public class ZTVWebSecurityConfigurer extends WebSecurityConfigurerAdapter {

	@Bean(name = BeanIds.AUTHENTICATION_MANAGER)
	@Override
	public AuthenticationManager authenticationManagerBean() throws Exception {
		return super.authenticationManagerBean();
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
				.antMatchers("/", "/admin/login", "/admin/verbaende", "/admin/anlaesse", "/admin/organisationen",
						"/favicon.ico", "/admin/user")
				.permitAll()
				// .antMatchers("/admin")
				// .access("@userAuthorizationControl.checkAccessBasedOnRoleBla(authentication)")
				.anyRequest().authenticated().and().httpBasic().and().cors().and().csrf().disable().logout();
		// .authenticationEntryPoint(authenticationEntryPoint)
		// http.headers().frameOptions().disable();
		// http.addFilterAfter(new CustomFilter(),
		// BasicAuthenticationFilter.class);
	}

//	protected void configure(HttpSecurity http) throws Exception {
//		http.authorizeRequests().antMatchers("/", "/admin/login", "/admin/user", "/admin/organisationen/**/*.*",
//				"/favicon.ico", "/h2-console", "/h2-console/**/*.*").permitAll().anyRequest().authenticated().and()
//				.httpBasic()
//		;
//		http.csrf().disable();
//		http.headers().frameOptions().disable();
//	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		String idForEncode = "bcrypt";
		Map<String, PasswordEncoder> encoders = new HashMap<>();
		encoders.put(idForEncode, new BCryptPasswordEncoder());
		encoders.put("noop", NoOpPasswordEncoder.getInstance());
		encoders.put("pbkdf2", new Pbkdf2PasswordEncoder());
		encoders.put("scrypt", new SCryptPasswordEncoder());
		encoders.put("sha256", new StandardPasswordEncoder());

		PasswordEncoder passwordEncoder = new DelegatingPasswordEncoder(idForEncode, encoders);
		return passwordEncoder;
	}

	/*
	 * AuthenticationManager ztvAuthenticationManager() { return authentication -> {
	 * authentication.getName() if (isCustomer(authentication)) { return new
	 * UsernamePasswordAuthenticationToken(credentials); } throw new
	 * UsernameNotFoundException(principal name); }; }
	 * 
	 * AuthenticationManagerResolver<HttpServletRequest> resolver() { return request
	 * -> { if (request.getPathInfo().startsWith("/employee")) { return
	 * ztvAuthenticationManager(); } return ztvAuthenticationManager(); }; }
	 */
}