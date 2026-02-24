import { defineConfig, DefaultTheme } from 'vitepress'
import pluginsSidebarData from './generated/plugins-sidebar.json'

const pluginsSidebar = pluginsSidebarData as DefaultTheme.SidebarItem[]

export default defineConfig({
  title: 'Claude Personas',
  description: 'Marketplace de personas (rôles spécialisés) pour Claude Code',
  base: '/claude-personas/',
  appearance: true,
  ignoreDeadLinks: true,

  vite: {
    server: {
      watch: {
        usePolling: true,
        ignored: [
          '**/node_modules/**',
          '**/.git/**',
          '**/dist/**',
        ]
      }
    }
  },

  head: [
    ['link', { rel: 'icon', href: '/claude-personas/favicon.ico' }],

    // Open Graph
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: 'Claude Personas' }],
    ['meta', { property: 'og:description', content: 'Personas (rôles spécialisés) pour Claude Code : analyst, architect, reviewer, tester et plus' }],
    ['meta', { property: 'og:url', content: 'https://atournayre.github.io/claude-personas/' }],
    ['meta', { property: 'og:image', content: 'https://atournayre.github.io/claude-personas/og-image.png' }],
    ['meta', { property: 'og:image:width', content: '1200' }],
    ['meta', { property: 'og:image:height', content: '630' }],
    ['meta', { property: 'og:image:alt', content: 'Claude Personas - Rôles spécialisés pour Claude Code' }],
    ['meta', { property: 'og:locale', content: 'fr_FR' }],

    // Twitter Card
    ['meta', { name: 'twitter:card', content: 'summary_large_image' }],
    ['meta', { name: 'twitter:title', content: 'Claude Plugin Marketplace' }],
    ['meta', { name: 'twitter:description', content: 'Écosystème complet de plugins, skills, agents et hooks pour Claude Code' }],
    ['meta', { name: 'twitter:image', content: 'https://atournayre.github.io/claude-personas/og-image.png' }]
  ],

  themeConfig: {
    logo: {
      light: '/logo-light.svg',
      dark: '/logo-dark.svg'
    },

    nav: [
      { text: 'Guide', link: '/guide/getting-started' },
      { text: 'Personas', link: '/plugins/' },
      { text: 'Skills', link: '/commands/' },
      { text: 'Agents', link: '/agents/' },
      { text: 'GitHub', link: 'https://github.com/atournayre/claude-personas' }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/atournayre/claude-personas' }
    ],

    footer: {
      message: 'Publié sous licence MIT',
      copyright: 'Copyright © 2026 Aurélien Tournayre'
    },

    editLink: {
      pattern: 'https://github.com/atournayre/claude-personas/edit/main/docs/:path',
      text: 'Modifier cette page sur GitHub'
    },

    sidebar: {
      '/guide/': [
        {
          text: 'Guide utilisateur',
          items: [
            { text: 'Démarrage rapide', link: '/guide/getting-started' },
            { text: 'Installation', link: '/guide/installation' },
            { text: 'Architecture slash commands', link: '/guide/workaround-slash-commands' }
          ]
        },
        {
          text: 'Contribution',
          items: [
            { text: 'Guide de contribution', link: '/guide/contributing' }
          ]
        }
      ],
      '/plugins/': pluginsSidebar
    },

    search: {
      provider: 'local',
      options: {
        locales: {
          root: {
            translations: {
              button: { buttonText: 'Rechercher' },
              modal: {
                noResultsText: 'Aucun résultat',
                footer: {
                  selectText: 'Sélectionner',
                  navigateText: 'Naviguer'
                }
              }
            }
          }
        }
      }
    }
  }
})
