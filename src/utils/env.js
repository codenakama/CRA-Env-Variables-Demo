function isBrowser() {
    return !!(typeof window !== 'undefined' && window.APP_CONFIG);
  }
  
  /**
   * If passed a key it returns the value for it in APP_CONFIG, otherwise returns the APP_CONFIG object
   * @param {*key - A key of the object APP_CONFIG } key
   */
  export function getEnv(key = '') {
    const safeKey = `REACT_APP_${key}`;
  
    if (isBrowser()) {
      return key.length ? window.APP_CONFIG[safeKey] : window.APP_CONFIG;
    }
  
    console.log(window.APP_CONFIG);
  
    console.log('Not a browser environment.');
    return undefined;
  }
  