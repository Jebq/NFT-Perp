import {Command, flags} from '@oclif/command'
import {fetchPrice, updatePrice} from '../helpers/prices'

export default class Prices extends Command {
  static description = 'Send floor-prices updates from a Tezos contract'

  static flags = {
    help: flags.help({char: 'h'}),
  }

  async run() {
    console.log('Start')
    try {
      const price = await fetchPrice()
      console.log(price)
      console.log('Update Price');
      await updatePrice(price)

      this.log(`price updated`)
    } catch (e) {
      this.error(e.message, { exit: 1 })
    }
  }
}
