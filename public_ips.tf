resource "aws_eip" "FW1-PUB" {
  vpc   = true
  depends_on = ["aws_vpc.single-pafw-skillet-vpc", "aws_internet_gateway.igw"]
}

resource "aws_eip" "FW1-MGT" {
  vpc   = true
  depends_on = ["aws_vpc.single-pafw-skillet-vpc", "aws_internet_gateway.igw"]
}