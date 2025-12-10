import { useTranslation } from 'react-i18next';

const LanguageSwitcher = () => {
  const { i18n } = useTranslation();

  const changeLanguage = (lng: string) => {
    i18n.changeLanguage(lng);
  };

  return (
    <div style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
      <button
        onClick={() => changeLanguage('sr')}
        style={{
          padding: '0.5rem 1rem',
          border: 'none',
          borderRadius: '4px',
          cursor: 'pointer',
          backgroundColor: i18n.language === 'sr' ? '#8B4513' : '#f0f0f0',
          color: i18n.language === 'sr' ? 'white' : '#333',
          fontWeight: i18n.language === 'sr' ? 'bold' : 'normal',
          transition: 'all 0.3s ease',
        }}
      >
        SR
      </button>
      <button
        onClick={() => changeLanguage('en')}
        style={{
          padding: '0.5rem 1rem',
          border: 'none',
          borderRadius: '4px',
          cursor: 'pointer',
          backgroundColor: i18n.language === 'en' ? '#8B4513' : '#f0f0f0',
          color: i18n.language === 'en' ? 'white' : '#333',
          fontWeight: i18n.language === 'en' ? 'bold' : 'normal',
          transition: 'all 0.3s ease',
        }}
      >
        EN
      </button>
    </div>
  );
};

export default LanguageSwitcher;
