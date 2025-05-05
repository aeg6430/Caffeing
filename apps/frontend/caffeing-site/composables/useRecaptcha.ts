export const useRecaptcha = () => {
  const config = useRuntimeConfig();

  const executeRecaptcha = async (action: string): Promise<string | null> => {
    return new Promise((resolve) => {
      if (!(window as any).grecaptcha) {
        console.warn('reCAPTCHA not loaded');
        return resolve(null);
      }

      (window as any).grecaptcha.ready(() => {
        (window as any).grecaptcha
          .execute(config.public.recaptchaSiteKey, { action })
          .then((token: string) => {
            resolve(token);
          });
      });
    });
  };

  return { executeRecaptcha };
};
