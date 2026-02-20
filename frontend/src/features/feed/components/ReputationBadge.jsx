import Badge from "../../../components/ui/Badge";

// interface Props {
//   reputation: number;
//   verified: boolean;
// }

export default function ReputationBadge({ reputation, verified }) {
  if (verified) {
    return <Badge variant="verified">Verified · {reputation}</Badge>;
  }

  return <Badge>Rep {reputation}</Badge>;
}
