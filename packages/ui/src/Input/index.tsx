import { forwardRef } from "react";

const InputBase = forwardRef<HTMLInputElement | null>(({ ...rest }, ref) => {
  return <input ref={ref} {...rest} />;
});

InputBase.displayName = "InputBase";

const RoundedInput = () => {
  return <div></div>;
};

export { InputBase, RoundedInput };
