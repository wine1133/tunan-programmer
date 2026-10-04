const DEFAULT_BASE_URL = 'http://127.0.0.1:8088'

let API_BASE_URL = DEFAULT_BASE_URL

// H5 公网访问时自动使用当前域名，避免请求访问者自己的 127.0.0.1。
// #ifdef H5
if (typeof window !== 'undefined' && window.location) {
	const origin = window.location.origin
	if (/^https?:\/\//i.test(origin) && (window.location.protocol === 'https:' || window.location.port === '8088')) {
		API_BASE_URL = origin
	}
}
// #endif

// Android 模拟器通过 10.0.2.2 访问宿主机；真机请改为电脑的局域网 IP。
// #ifdef APP-PLUS
API_BASE_URL = 'http://10.0.2.2:8088'
// #endif

export { API_BASE_URL }

export function request(options) {
	const requestOptions = Object.assign({}, options, {
		url: /^https?:\/\//i.test(options.url) ? options.url : API_BASE_URL + options.url,
		timeout: options.timeout || 10000
	})

	return uni.request(requestOptions)
}