package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	cobra "github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	// TeleToken Bot
	TeleToken = os.Getenv("TELE_TOKEN")
)

// appVersion should be set at build time using the -ldflags option
var appVersion string

var kbotCmd = &cobra.Command{
	Use:   "kbot",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
	and usage of using your command. For example: `,

	Run: func(cmd *cobra.Command, args []string) {

		fmt.Printf("kbot %s started\n", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {

	      //log.Print(m.Message().Payload, m.Text())
			log.Printf("Payload %s , Text: %s", m.Message().Payload, m.Text())
			payload := m.Text()

			switch payload {
			case "hello":
				log.Print(m.Message().Payload, m.Text())
				err = m.Send(fmt.Sprintf("Hello I'm tobK %s!", appVersion))
			default:
				err = m.Send(fmt.Sprint("Enter \"hello\" bitch!"))
			}
			return err
		})

		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// kbotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// kbotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
