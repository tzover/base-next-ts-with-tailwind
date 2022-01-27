import React from 'react'
import { act, cleanup, render, screen } from '@testing-library/react'
import Home from '../../pages'

/* 実施するテストケース

- レンダリング
*/

jest.mock('next/router', () => ({
  useRouter() {
    return {
      asPath: '/',
    }
  },
}))

beforeEach(() => {
  cleanup()
})

afterEach(() => {
  cleanup()
})

describe('Unit', () => {
  it('Rendering', () => {
    act(() => {
      render(<Home />)
    })
    expect(screen.findByText('Welcome to Next.js!')).toBeTruthy()
  })
})
