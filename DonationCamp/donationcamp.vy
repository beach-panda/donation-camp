struct Donator :
  sender: address
  value: wei_value

donators: map(int128, Donator)
nextDonatorIndex: int128
needer: address
deadline: public(timestamp)
goal: public(wei_value)
timelimit: public(timedelta)


@public
def __init__(_needer: address, _goal: wei_value, _timelimit: timedelta):
    self.needer = _needer
    self.deadline = block.timestamp + _timelimit
    self.timelimit = _timelimit
    self.goal = _goal


@public
@payable
def donate4csz():
    assert block.timestamp < self.deadline, "Time still remaining"
    ndi: int128 = self.nextDonatorIndex
    self.donators[ndi] = Donator({sender: msg.sender, value: msg.value})
    self.nextDonatorIndex = ndi + 1


@public
def confirm():
    assert block.timestamp >= self.deadline, "Time still remaining"
    assert self.balance >= self.goal, "Check your pockets"

    selfdestruct(self.needer)