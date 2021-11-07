import React, { } from "react";
import styled from 'styled-components';

const ButtonLayout = styled.button`
  color: #fff;
  font-size: 1rem;
  padding: 15px;
  margin: 8px 8px 8px 8px;
  background-color: #696969;
  border: solid 2px #000;
  border-radius: 40px;
  outline: none;
  cursor: pointer;
  transition: 0.2s;

  :hover {
    color: #e6e6e6;
    background-color: #404040;
  }

  :active {
    margin-top: 5px;
    margin-bottom: 0px;
  }
`
interface ButtonProps {
  text: string;
  onClick: React.MouseEventHandler<HTMLButtonElement> | undefined;
}

export default function Button({
    text,
    onClick
  }: ButtonProps) {

  return (
      <ButtonLayout onClick={ onClick }>
        { text }
      </ButtonLayout>
  )
}